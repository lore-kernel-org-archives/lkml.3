Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaAZVuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:50:10 -0500
Received: from plane.gmane.org ([80.91.229.3]:44034 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaAZVuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:50:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sebastian Steinhuber <sebastian.steinhuber@googlemail.com>
Subject: Re: Panic with latest git kernel
Date: Sun, 26 Jan 2014 21:42:27 +0100
Message-ID: <lc3rv7$nkf$1@ger.gmane.org>
References: <52E50496.3040303@gmail.com> <CAFLxGvx8OQzSzoikh9DT3VF=cdBw4=sU_ZM=BTs=M4Ts84eGgA@mail.gmail.com> <52E50ED7.9070808@gmail.com> <52E50F72.9060300@nod.at> <52E51FEE.4020403@gmail.com> <52E52300.7020008@nod.at> <52E568C2.5050001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5491c699.dip0.t-ipconnect.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.2.0
In-Reply-To: <52E568C2.5050001@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.01.2014 20:57, schrieb Harald Arnesen:
> Seems you are right. I just tried to compile a 3.13.0 kernel again
> (which I did when i was released, and it worked then), and I got the
> same panic.
>
> Must be a Debian bug. I will pester them instead.

I had to downgrade busybox-static to 1.21.0-1 (testing)


