Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbbALPQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:16:28 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:54985 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbbALPQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:16:27 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Mon, 12 Jan 2015 10:16:25 -0500
To: Rob Landley <rob@landley.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] out out damn perl
Message-ID: <20150112151625.GA30247@csclub.uwaterloo.ca>
References: <54AC72AF.5090609@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AC72AF.5090609@landley.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:41:35PM -0600, Rob Landley wrote:
> From: Rob Landley <rob@landley.net>
> 
> Commit e6023367d779 added perl back to the kernel build in -rc6.
> Replace 39 lines of perl with 4 lines of shell script.

Maybe checkpatch should be updated to look for perl. :)

-- 
Len Sorensen
