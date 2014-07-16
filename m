Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbaGPCu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 22:50:56 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:60941 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaGPCuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 22:50:54 -0400
MIME-Version: 1.0
Date: Tue, 15 Jul 2014 22:50:53 -0400
Message-ID: <CAPDOMVggidq18zBrnVbS=P-DRjTd8K4zYemiNs=OnmbqTXGNAg@mail.gmail.com>
Subject: Checkpatch Feature Idea: Search directory for files with errors and
 warnings with -d argument
From: Nick Krause <xerofoify@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, josh@joshtriplett.org, robh@kernel.org,
        florian.vaussard@epfl.ch,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I may have not found it myself but if it doesn't exist can we write a
feature for checkpatch to be able to recursively
search a directory structure with a -d argument in order to make it
easier to search larger directories for files that still
need cleanup for files having kernel coding style issues. Furthermore
I am asking you guys to write this feature
if you feel this is a good idea as I am only a beginner in perl. I can
help out by testing  it however if needed :).
Cheers Nick
