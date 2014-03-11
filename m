Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbaCKXHb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 19:07:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbaCKXHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 19:07:30 -0400
Date: Tue, 11 Mar 2014 16:08:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Breeds <tony@bakeyournoodle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3.4 25/99] powerpc/le: Ensure that the stop-self RTAS
 token is handled correctly
Message-ID: <20140311230816.GA7626@kroah.com>
References: <20140308010611.468206150@linuxfoundation.org>
 <20140308010612.425643961@linuxfoundation.org>
 <20140310104007.GB2742@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140310104007.GB2742@hercules>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:40:07AM +0000, Luís Henriques wrote:
> On Fri, Mar 07, 2014 at 05:07:21PM -0800, Greg Kroah-Hartman wrote:
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> As per Tony request, I've dropped this patch from the 3.5 kernel.  Looks
> like it is applicable to kernels >= 3.10, so I guess you can drop it from
> 3.4 as well.

Thanks, now dropped.

greg k-h
