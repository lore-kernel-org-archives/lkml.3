Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab3BVS5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:57:48 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:46934 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BVS5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:57:45 -0500
Date: Fri, 22 Feb 2013 19:57:41 +0100
From: Olaf Hering <aepfle@gmail.com>
To: Tomas Hozza <thozza@redhat.com>
Cc: gregkh@linuxfoundation.org, kys@microsoft.com, jasowang@redhat.com,
        haiyangz@microsoft.com, linux-kernel@vger.kernel.org,
        habdi@microsoft.com
Subject: Re: [PATCH] tools: hv: Fix how ifcfg-* file is created
Message-ID: <20130222185741.GA10588@gmail.com>
References: <1986454953.1148002.1357891354839.JavaMail.root@redhat.com>
 <1358112460-32744-1-git-send-email-thozza@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1358112460-32744-1-git-send-email-thozza@redhat.com>
User-Agent: Mutt/1.5.21.rev5638 (2013-02-08)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, Tomas Hozza wrote:

> -# IPADDR=ipaddr1
> -# IPADDR_1=ipaddr2
> -# IPADDR_x=ipaddry (where y = x + 1)
> +# IPADDR0=ipaddr1
> +# IPADDR1=ipaddr2
> +# IPADDRx=ipaddry (where y = x + 1)

Before this change it was IPADDR=, now its IPADDR0=.
Furthermore, IPADDR_n was changed to IPADDRn.
Does that match what the tools consuming the ifcfg-* files expect?
Why did it work before this change?


Olaf
