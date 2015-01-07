Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbbAGNGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:06:44 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54461 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751943AbbAGNGm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:06:42 -0500
X-Sasl-enc: gvvteaxoRxwTjQtXLiFFuMz/xrwCxthRazm+7r43R5xr 1420636001
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: TCP connection issues against Amazon S3
From: Erik Grinaker <erik@bengler.no>
In-Reply-To: <DUB123-W1008C526C7E0FA115A87EED460@phx.gbl>
Date: Wed, 7 Jan 2015 13:06:39 +0000
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Yuchung Cheng <ycheng@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6156B1A1-29C5-46D8-949E-0A296D5E85A2@bengler.no>
References: <5DCDADEF-FF9C-4844-8A2C-62E2D3B3B8CE@bengler.no> <1420560253.32621.20.camel@edumazet-glaptop2.roam.corp.google.com> <D5C36777-4461-4B8D-B6C4-38B4276F42DC@bengler.no> <1420564837.32621.30.camel@edumazet-glaptop2.roam.corp.google.com> <8C4F7938-DCA1-46F5-A3C9-7DF62511DEE7@bengler.no> <CAK6E8=d5Z0W5sSAdeEcecKbqjj_UwGw4949=a20fetFpLVKwwA@mail.gmail.com> <03FC652E-AA01-42C7-BD52-019B6D922A9C@bengler.no> <CAK6E8=cP0BFUob5MVj9M0hC0efgRnUY=JMUPKee+v-4TLvHBgg@mail.gmail.com> <76DC89D1-CFCE-44B7-994E-4349FEEDEFA6@bengler.no> <1420575216.5947.12.camel@edumazet-glaptop2.roam.corp.google.com> <4DA8529D-4EEC-42DA-89B0-DC7746DB2B10@bengler.no> <,<3F608393-E5F1-4647-81BF-C6C740100934@bengler.no> <>> <DUB123-W1008C526C7E0FA115A87EED460@phx.gbl>
To: Lukas Tribus <luky-37@hotmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07 Jan 2015, at 01:23, Lukas Tribus <luky-37@hotmail.com> wrote:
>> This still doesn’t explain why it works with older kernels, but not newer ones.
> 
> Can you try the different 3.12-rc kernels? The information that this was
> introduced in 3.12-rc1 as opposed to a specific -rc>1 releases may help
> the guys here to pinpoint what exactly caused the behavior change on the
> receiver side.

I can reproduce the problem with 3.12.0-rc1 as well.

I also tried 3.11.10 again, to make sure it did not have the problem even when forcing requests to a non-SACK-enabled loadbalancer, and it works as it should (no hung connections).


