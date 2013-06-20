Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869Ab3FTNgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 09:36:32 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:38889 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab3FTNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 09:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <51C21645.3050108@google.com>
References: <51C21645.3050108@google.com>
From: Tristan Schmelcher <tschmelcher@google.com>
Date: Thu, 20 Jun 2013 09:36:05 -0400
Message-ID: <CADNZ+wRMzCxeUr5nUU43TunCsdN4+S8wHkzAVYvQPsq9G0=PwQ@mail.gmail.com>
Subject: Re: [PATCHv2] uml: Fix which_tmpdir failure when /dev/shm is a
 symlink, and in other edge cases
To: Richard Weinberger <richard@nod.at>, jdike@addtoit.com
Cc: user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*sigh* found another bug. Gonna sit on the patch for a bit before
sending v3, just in case I find more issues.
