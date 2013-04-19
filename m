Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab3DSIFl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:05:41 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60532 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3DSIFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:05:34 -0400
Date: Fri, 19 Apr 2013 10:05:19 +0200
From: Anisse Astier <anisse@astier.eu>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>
Subject: Re: [PATCH 1/2] deb-pkg: split debug symbols in their own package
Message-ID: <20130419100519.485cb557@serenity>
In-Reply-To: <20130409120547.64ad0d50@serenity>
References: <1363946761-7449-1-git-send-email-anisse@astier.eu>
	<51629BFF.1080204@suse.cz>
	<20130408190645.29570fe5@serenity>
	<20130409120547.64ad0d50@serenity>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013 12:05:47 +0200, Anisse Astier <anisse@astier.eu> wrote :

> 
> 
> From: Anisse Astier <anisse@astier.eu>
> Subject: [PATCH v3] deb-pkg: split debug symbols in their own package
> 
> This can reduce almost 3 times the size of the linux-image package,
> while keeping the debug symbols available for this particular build, in
> their own package.
> 
> This mimics the way kernels are built in debian, ubuntu, or with
> make-kpkg, and comes at the price of a small slowdown in the building of
> packages.
> 
> v2:
>  - only build when CONFIG_DEBUG_INFO=y
>  - build debug package last.
>  - more verbose package description
>  - put package in section debug
> v3:
>  - remove duplicate code from v2
> 

What do you think ?
