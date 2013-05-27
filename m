Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3E0HrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:47:05 -0400
Received: from sam.nabble.com ([216.139.236.26]:52931 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab3E0HrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:47:04 -0400
Date: Mon, 27 May 2013 00:47:03 -0700 (PDT)
From: johnspaul92 <johns@ti.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1369640823167-656004.post@n7.nabble.com>
Subject: why do we need atomic_set_unchecked
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When i tried to apply the GrSecurity patch on linux kernel 3.10 and there the
patch actually modifies atomic_set to atomic_set_unchecked. When i checked
the gcc patch to compile this code it just redefines atomic_set as
atomic_set_unchecked. So what is the use of changing the function name.?? Am
I missing something here(i.e have they given a new definition for this
function anywhere else). And i would also like to know what this
function(atomic_set_unchecked. I know about the atomic_set function)  is
used for.



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/why-do-we-need-atomic-set-unchecked-tp656004.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
