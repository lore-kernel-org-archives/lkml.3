Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab3B0GUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 01:20:38 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:22704 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab3B0GUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 01:20:37 -0500
Date: Wed, 27 Feb 2013 07:20:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: mchehab@redhat.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/9] mfd: Add header files and Kbuild plumbing for
	SI476x MFD core
Message-ID: <20130227062032.GA26583@merkur.ravnborg.org>
References: <1361945213-4280-1-git-send-email-andrew.smirnov@gmail.com> <1361945213-4280-5-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361945213-4280-5-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 10:06:48PM -0800, Andrey Smirnov wrote:
> This patch adds all necessary header files and Kbuild plumbing for the
> core driver for Silicon Laboratories Si476x series of AM/FM tuner
> chips.
> 
> The driver as a whole is implemented as an MFD device and this patch
> adds a core portion of it that provides all the necessary
> functionality to the two other drivers that represent radio and audio
> codec subsystems of the chip.
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
