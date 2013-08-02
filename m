Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3HBC2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:28:33 -0400
Received: from ozlabs.org ([203.10.76.45]:33023 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3HBC2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:28:32 -0400
Date: Fri, 2 Aug 2013 12:28:28 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 2/8] Mark powerpc memory resources as busy
Message-ID: <20130802022827.GB1680@concordia>
References: <51F01E06.6090800@linux.vnet.ibm.com>
 <51F01EB2.9060802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F01EB2.9060802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:36:34PM -0500, Nathan Fontenot wrote:
> Memory I/O resources need to be marked as busy or else we cannot remove
> them when doing memory hot remove.

I would have thought it was the opposite?

cheers
