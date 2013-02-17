Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3BQWbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:31:45 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:38135 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135Ab3BQWbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:31:44 -0500
Date: Sun, 17 Feb 2013 16:01:43 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] DocBook: update EXPORT_SYMBOL entry to point at
 export.h
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-doc@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Kosina <trivial@kernel.org>
References: <1360873924-29368-1-git-send-email-paul.gortmaker@windriver.com>
In-Reply-To: <1360873924-29368-1-git-send-email-paul.gortmaker@windriver.com>
	(from paul.gortmaker@windriver.com on Thu Feb 14 14:32:04 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1361138503.29465.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2013 02:32:04 PM, Paul Gortmaker wrote:
> Previously we used to get EXPORT_SYMBOL and friends from
> module.h but we moved away from that since module.h largely
> includes the entire header space one way or another.
> 
> As most users just wanted the simple export related macros,
> they were spun off into a separate new header -- export.h
> Update the docs to reflect that.
> 
> Suggested-by: Borislav Petkov <bp@alien8.de>
> Cc: Rob Landley <rob@landley.net>
> Cc: Jiri Kosina <trivial@kernel.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Rob Landley <rob@landley.net>

Rob