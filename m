Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaKVTBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:01:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaKVTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:01:41 -0500
Date: Sat, 22 Nov 2014 11:00:18 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Adrian Nicoara <anicoara@uwaterloo.ca>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: lustre: Fix sparse warnings for static
 declarations
Message-ID: <20141122190018.GA26638@kroah.com>
References: <20141111051528.GB24026@uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111051528.GB24026@uwaterloo.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:15:28AM -0500, Adrian Nicoara wrote:
> All the changes are against variables/functions that are only accessed from
> within the same file. If the scope needs to change later on, the static keyword
> can be removed.
> 
> Build tested.
> 
> Signed-off-by: Adrian Nicoara <anicoara@uwaterloo.ca>

Adds a few build warnings, so I can't take this patch, sorry :(

ALWAYS test your patches.
