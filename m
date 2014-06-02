Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155AbaFBNPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:15:00 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34704 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbaFBNO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:14:58 -0400
Date: Mon, 2 Jun 2014 14:14:45 +0100
From: John Church <sleeveroller@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: gregkh@linuxfoundation.org, lisa@xenapiadmin.com, bergwolf@gmail.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        doug.s.oucharek@intel.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix sparse warnings for undeclared
 symbols
Message-ID: <20140602131443.GA3983@gmail.com>
References: <1401710628-3690-1-git-send-email-sleeveroller@gmail.com>
 <20140602121918.GZ15585@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602121918.GZ15585@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 03:19:18PM +0300, Dan Carpenter wrote:
> 
> Why not just make them static?  They don't seem to be used outside of
> that file.  What am I missing?
> 

Given a 50/50 choice I based my decision on the surrounding functions which were mostly defined in the header file.

I should have done a little more invstigation which would have led me to the opposite conclusion.

I will redo them as static and resumbit.

Thanks for your help Dan.

Regards,
John
