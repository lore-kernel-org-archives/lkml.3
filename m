Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3JXOET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:04:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55915 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab3JXOES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:04:18 -0400
Message-ID: <52692896.70901@ahsoftware.de>
Date: Thu, 24 Oct 2013 16:03:02 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Aldo Iljazi <me@aldo.io>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposal for menuconfig removal
References: <688fb505375d3c5fa1f8d00c81a9dab2@aldo.io>
In-Reply-To: <688fb505375d3c5fa1f8d00c81a9dab2@aldo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.10.2013 13:56, schrieb Aldo Iljazi:
> Since nconfig is there, menuconfig is redundant.
> 
> I am proposing to remove it from the kernel.
> 

Looks like nconfig depends on F-keys, which unfortunately do disappear
more and more on modern keyboards, so I wouldn't call that a very good idea.

Regards,

Alexander Holler
