Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3AUHlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:41:44 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:39305 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3AUHln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:41:43 -0500
MIME-Version: 1.0
In-Reply-To: <CADGQE7GnR2e-RN6A7iAS1BHCL9odH09z+ds8NdM3bL0hfsLf9A@mail.gmail.com>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
	<CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg@mail.gmail.com>
	<CADGQE7GnR2e-RN6A7iAS1BHCL9odH09z+ds8NdM3bL0hfsLf9A@mail.gmail.com>
Date: Mon, 21 Jan 2013 01:41:42 -0600
Message-ID: <CAH2r5mvK6gCqRSh-75a7mqRAH3O-QGvdvhv_VxN1FRxDVv-ctw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
From: Steve French <smfrench@gmail.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Wed, Jan 16, 2013 at 10:04 PM, Nickolai Zeldovich
<nickolai@csail.mit.edu> wrote:
> On Wed, Jan 16, 2013 at 10:51 PM, Steve French <smfrench@gmail.com> wrote:
>> How did you discover this - did you have an ipv6 test case or by
>> inspection or ...?
>
> By mostly-automated inspection (i.e., with the help of a static
> program analysis tool).
>
> Nickolai.



-- 
Thanks,

Steve
