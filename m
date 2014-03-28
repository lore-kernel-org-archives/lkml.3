Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbaC1Ass (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 20:48:48 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:56837 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258AbaC1Asr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 20:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
References: <1395967502-71219-1-git-send-email-chrisfriedt@gmail.com>
From: Christopher Friedt <chrisfriedt@gmail.com>
Date: Thu, 27 Mar 2014 20:48:26 -0400
Message-ID: <CAF4BF-SUafSBWBh5WawCgT=4EhGorDtxNpbtA6oAiFbYZpBGTg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drm/vmwgfx: correct fb_fix_screeninfo.line_length
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 2nd time I've posted the patch. Please have a look Dave.
Gregkh suggested I resend this a while back after not hearing any
feedback.

It's a fairly simple patch. Don't forget to look at

https://bugs.gentoo.org/show_bug.cgi?id=494794

because that kind of describes it all.
