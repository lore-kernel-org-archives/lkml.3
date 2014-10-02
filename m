Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaJBRDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:03:35 -0400
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:50210 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751661AbaJBRDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:03:33 -0400
Date: Thu, 2 Oct 2014 12:03:30 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: generalize VM_BUG_ON() macros
In-Reply-To: <20141001130523.d7cf46e735089d681194e8e6@linux-foundation.org>
Message-ID: <alpine.DEB.2.11.1410021202370.4190@gentwo.org>
References: <1412163121-4295-1-git-send-email-kirill.shutemov@linux.intel.com> <20141001130523.d7cf46e735089d681194e8e6@linux-foundation.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014, Andrew Morton wrote:

> I can't say I'm a fan of this.  We don't do this sort of thing anywhere
> else in the kernel and passing different types to the same thing in
> different places is unusual and exceptional.  We gain very little from
> this so why bother?

I feel the same. This smells awfully like C++ overloading of functions
etc which I think often confuses the heck out of people.

