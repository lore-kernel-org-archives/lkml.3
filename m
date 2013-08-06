Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3HFIOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:14:15 -0400
Received: from intranet.asianux.com ([58.214.24.6]:19123 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3HFION (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:14:13 -0400
X-Spam-Score: -100.8
Message-ID: <5200B017.7030401@asianux.com>
Date: Tue, 06 Aug 2013 16:13:11 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>, holt@sgi.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: kernel/sys.c: for setfsuid(), return the current uid when error occurs
References: <5200AD26.8070701@asianux.com>
In-Reply-To: <5200AD26.8070701@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are 2 related patches for setfsuid().

Patch 1 for bug fix: return the current uid when error occurs.
Patch 2 for cleaning code: remove useless variable 'old_fsuid'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
--
 kernel/sys.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)
