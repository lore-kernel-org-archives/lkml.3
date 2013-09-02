Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3IBQtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:49:42 -0400
Received: from verein.lst.de ([213.95.11.211]:34205 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171Ab3IBQtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:49:41 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Sep 2013 12:49:41 EDT
Date: Mon, 2 Sep 2013 18:41:37 +0200 (CEST)
From: Torsten Duwe <duwe@lst.de>
Reply-To: Torsten Duwe <duwe@lst.de>
To: tytso@mit.edu
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] s390: provide hardware randomness from zcrypt card to
 /dev/random
Message-ID: <alpine.LNX.2.00.1309021831020.2540@linux.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: LST e.V.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted!

A while ago a colleague asked me if it was possible to speed up system 
startup on IBM system Z that was slow because of ASLR and the entropy pool 
was empty. They had recently intoduced new crypto cards that featured good 
hardware random generators. My resulting code has meanwhile taken a good 
amount of testing and a bunch of corner cases were fixed. It should now be 
ready for mainline.

	Torsten
