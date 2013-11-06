Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3KFL6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:58:10 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:47258 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab3KFL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:58:07 -0500
Date: Wed, 6 Nov 2013 15:58:05 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Oleg Nesterov <oleg@redhat.com>, Andrey Vagin <avagin@openvz.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/7] seq-file: Export single_ helpers
Message-ID: <20131106115805.GA5395@moon>
References: <20131106114742.988532945@openvz.org>
 <20131106114812.474330639@openvz.org>
 <20131106115054.GA19352@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106115054.GA19352@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:50:54AM -0800, Christoph Hellwig wrote:
> On Wed, Nov 06, 2013 at 03:47:43PM +0400, Cyrill Gorcunov wrote:
> > The single_ helpers will be used in fdinfo output to
> > eliminate code duplication.
> 
> There is no need to export symbols just to use them in procfs or
> eventfd, which are always built in.

I still need to declare them (they were static), so since single-open
already exported I thought I need to export the rest of single_ helper
as well.
