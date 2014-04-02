Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030643AbaDBWPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:15:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932972AbaDBWPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:15:13 -0400
Date: Wed, 2 Apr 2014 23:15:08 +0100
From: Mel Gorman <mgorman@suse.de>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cyeoh@au1.ibm.com
Subject: Re: Suggestion, "public process scoped interfaces"
Message-ID: <20140402221508.GB1869@suse.de>
References: <fa9ecac225ee2.533c5ee6@langara.bc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <fa9ecac225ee2.533c5ee6@langara.bc.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 07:03:02PM +0000, Steven Stewart-Gallus wrote:
> Hello,
> 
> I have been reconsidering requirements and solutions brought up in my
> post "How about allowing processes to expose memory for cross memory
> attaching?".

commit fcf634098c00dd9cd247447368495f0b79be12d1

-- 
Mel Gorman
SUSE Labs
