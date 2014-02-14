Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaBNJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:30:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBNJaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:30:21 -0500
Date: Fri, 14 Feb 2014 12:30:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [patch] Documentation/SubmittingPatches: Reported-by tags and
 permission
Message-ID: <20140214093001.GA15933@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392333751.29034.3.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reported-by text says you have to ask for permission, but that's
only if the bug was reported in private.  These days the standard is to
always give reported-by credit or it's considered a bit rude.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 26b1e31d5a13..f72ce7803b71 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -432,12 +432,9 @@ have been included in the discussion
 
 14) Using Reported-by:, Tested-by:, Reviewed-by: and Suggested-by:
 
-If this patch fixes a problem reported by somebody else, consider adding a
-Reported-by: tag to credit the reporter for their contribution.  Please
-note that this tag should not be added without the reporter's permission,
-especially if the problem was not reported in a public forum.  That said,
-if we diligently credit our bug reporters, they will, hopefully, be
-inspired to help us again in the future.
+The Reported-by tag is to give credit to people who find bugs and report them.
+Please note that if the bug was reported in private, then ask for permission
+first before using the Reported-by tag.
 
 A Tested-by: tag indicates that the patch has been successfully tested (in
 some environment) by the person named.  This tag informs maintainers that
