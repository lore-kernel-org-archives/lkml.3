Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbaG0TaU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 15:30:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36161 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaG0TaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 15:30:18 -0400
Date: Sun, 27 Jul 2014 21:29:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Randy Dunlap <rdunlap@infradead.org>, Pali Roh?r <pali.rohar@gmail.com>,
        Stefan Weil <sw@weilnetz.de>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: laptops: freefall.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Message-ID: <20140727192950.GA32432@Nokia-N900>
References: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406472043-12272-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-07-27 16:40:43, Rickard Strandqvist wrote:
> Added a guaranteed null-terminate after call to strncpy.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Pavel Machek <pavel@ucw.cz>
