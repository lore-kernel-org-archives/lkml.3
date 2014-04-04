Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaDDUjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:39:42 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58551 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaDDUjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:39:40 -0400
Date: Fri, 4 Apr 2014 14:39:36 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Ryan Desfosses <ryan@desfo.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] pci: added space before the open parenthesis
Message-ID: <20140404203936.GA13931@google.com>
References: <1396635490-3630-1-git-send-email-ryan@desfo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396635490-3630-1-git-send-email-ryan@desfo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 02:18:10PM -0400, Ryan Desfosses wrote:
> change made to resolve checkpatch.pl error
> 
> Signed-off-by: Ryan Desfosses <ryan@desfo.org>

Hi Ryan,

Thanks for this and your previous fix.  This "Signed-off-by" looks good.
Would you mind reposting the "pci_bus*" fix with a similar "Signed-off-by"?
It's a small fix, but strictly speaking, I need the "Signed-off-by" before
I can apply a patch.

We normally write the changelog so it can stand alone, i.e., you shouldn't
have to read the summary in addition to the changelog for it to make sense.
It might be useful to browse other changelogs, e.g., with "git log
--no-merges drivers/pci".  I do often fix capitalization, spelling, and
other errors because I think consistency makes it easier to read the
history.

The "[2/2]" notation suggests that there's another patch labeled "[1/2]"
(and probably an overall summary labeled "[0/2]"), and that all were posted
together.  In this case, I think you intended your "pci_bus*" patch to be
[1/2], but since they weren't posted together, it's a bit harder for me to
keep track of them as a group.

If you don't mind, I'll collect up this and your previous fix (and any
future ones you find) and squash them into a single "whitespace fixes" sort
of patch to reduce the number of commits for obviously-correct changes.

Thanks again, and welcome to Linux kernel development!

Oh, and I applied the patch below to my pending/misc branch (and I'll
update it with the other one when you post it).  I have a few other things
I hope to ask Linus to put in v3.15 yet, and I'll include this.

Bjorn



From: Ryan Desfosses <ryan@desfo.org>

PCI: Fix whitespace issues

Resolve whitespace issues that checkpatch.pl complained about.

No functional change.

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7325d43bf030..1f0bf2eec127 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -114,7 +114,7 @@ unsigned char pci_bus_max_busnr(struct pci_bus* bus)
 	max = bus->busn_res.end;
 	list_for_each_entry(tmp, &bus->children, node) {
 		n = pci_bus_max_busnr(tmp);
-		if(n > max)
+		if (n > max)
 			max = n;
 	}
 	return max;
