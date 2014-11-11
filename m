Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaKKEgw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:36:52 -0500
Received: from scspc499.cs.uwaterloo.ca ([129.97.171.80]:50285 "EHLO
	scspc499.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaKKEgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:36:51 -0500
Date: Mon, 10 Nov 2014 23:36:44 -0500
From: Adrian Nicoara <anicoara@uwaterloo.ca>
To: oleg.drokin@intel.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: Fix sparse warnings for static
 declarations
Message-ID: <20141111043644.GA24026@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> All the changes are against variables/functions that are only accessed from
> within the same file. If the scope needs to change later on, the static
> keyword
> can be removed.
>
> Compile tested.

Correction - I somehow missed a compile error.
Disregard this patch, I'll follow up with a correct one.
Sorry about that.
