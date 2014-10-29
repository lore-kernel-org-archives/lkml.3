Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaJ2KB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:01:57 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:45344 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaJ2KBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:01:54 -0400
Date: Wed, 29 Oct 2014 13:01:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Landley <rob@landley.net>, Paul Bolle <pebolle@tiscali.nl>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [patch v2] Documentation/SubmittingPatches: Reported-by tags and
 permission
Message-ID: <20141029100136.GA14718@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028090451.41ed6aad@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reported-by text says you have to ask for permission, but that
should only be if the bug was reported in private.  These days the
standard is to always give reported-by credit or it's considered a bit
rude.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 482c749..1fa1caa 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -483,12 +483,10 @@ have been included in the discussion
 
 14) Using Reported-by:, Tested-by:, Reviewed-by:, Suggested-by: and Fixes:
 
-If this patch fixes a problem reported by somebody else, consider adding a
-Reported-by: tag to credit the reporter for their contribution.  Please
-note that this tag should not be added without the reporter's permission,
-especially if the problem was not reported in a public forum.  That said,
-if we diligently credit our bug reporters, they will, hopefully, be
-inspired to help us again in the future.
+The Reported-by tag gives credit to people who find bugs and report them and it
+hopefully inspires them to help us again in the future.  Please note that if
+the bug was reported in private, then ask for permission first before using the
+Reported-by tag.
 
 A Tested-by: tag indicates that the patch has been successfully tested (in
 some environment) by the person named.  This tag informs maintainers that
