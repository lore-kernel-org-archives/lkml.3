Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3FNUrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 16:47:46 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36582 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3FNUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 16:47:44 -0400
Date: Fri, 14 Jun 2013 21:47:40 +0100
From: Ross Lagerwall <rosslagerwall@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Possible tty VT1 disallocate regression
Message-ID: <20130614204740.GA706@hobo.wolfson.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ever since commit 421b40a6286e ("tty/vt: Fix vc_deallocate() lock
order"), the first VT does not clear when I log out.  AFAIK, this means
that disallocation is not working?  The problem only affects the first
VT, the others clear when logging out.

Regards
-- 
Ross Lagerwall
