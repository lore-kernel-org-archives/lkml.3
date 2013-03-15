Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3COTRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:17:34 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36124 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab3COTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:17:32 -0400
Date: Fri, 15 Mar 2013 12:17:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, Juan David Gonzalez Cobas <dcobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 3/8] FMC: add core bus driver
Message-ID: <20130315191729.GA11988@kroah.com>
References: <cover.1361469465.git.rubini@gnudd.com>
 <bfc3a24221b75d3a742da638102e25bea70ca930.1361469466.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfc3a24221b75d3a742da638102e25bea70ca930.1361469466.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 07:14:01PM +0100, Alessandro Rubini wrote:
> -/* Every device must have a release method: provide a default */
> +/* We really have nothing to release in here */
>  static void __fmc_release(struct device *dev) { }

Then your implementation is wrong, and as per the documentation in the
kernel Documentation directory (kobject.txt), I get to make fun of you
in public for trying to do this :)

Please fix this up, this isn't ok.

greg k-h
