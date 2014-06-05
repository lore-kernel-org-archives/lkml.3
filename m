Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaFEWab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:30:31 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63922 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaFEWa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:30:27 -0400
Date: Thu, 5 Jun 2014 15:30:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: eric ernst <eric.ernst@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, rdunlap@infradead.org,
        jwboyer@fedoraproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] Add kernel parameter for kernel version
In-Reply-To: <5390EC1B.3000706@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1406051528120.30564@chino.kir.corp.google.com>
References: <538CC567.2060305@linux.intel.com> <1402006157-126864-1-git-send-email-eric.ernst@linux.intel.com> <20140605151633.7dd15e8307cbd3b519ae257b@linux-foundation.org> <5390EC1B.3000706@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, eric ernst wrote:

> We have a need to keep a single product binary (kernel) across multiple
> android devices.  A subset of these platforms are looking for extra versioning
> information appended to it, accessible via /proc/version.  Rather than build
> multiple otherwise identical kernels with only this extended versioning as
> differentiation, we are looking to make this a command line parameter.
> Understandable if there isn't enough value-add for the community in this
> patch, but I figured I'd give the patch a shot, as we need this functionality
> locally.  Thanks.

Unrecognized parameters on the kernel command line are disregarded, so 
your platforms should be able to parse /proc/cmdline for 
version_addendum=foo already.
