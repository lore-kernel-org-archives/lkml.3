Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3EPV7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 17:59:09 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:39589 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3EPV7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 17:59:07 -0400
Date: Wed, 15 May 2013 18:00:35 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [patch] Documentation: allow multiple return statements per
 function
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
References: <20130515172021.GA304@elgon.mountain>
In-Reply-To: <20130515172021.GA304@elgon.mountain> (from
	dan.carpenter@oracle.com on Wed May 15 12:20:21 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1368658835.18069.250@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 12:20:21 PM, Dan Carpenter wrote:
> A surprising number of newbies interpret this section to mean that  
> only
> one return statement is allowed per function.  Part of the problem is
> that the "one return statement per function" rule is an actual style
> guideline that people are used to from other projects.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Ack, please forward to trivial tree.

Rob