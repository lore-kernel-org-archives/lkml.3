Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3GYXkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:40:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3GYXkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:40:08 -0400
Date: Thu, 25 Jul 2013 16:40:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nivedita Singhvi <niv@us.ibm.com>, Michael J Wolf <mjwolf@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: base: new memory config sysfs driver for large
 memory systems
Message-ID: <20130725234007.GB18349@kroah.com>
References: <1374786680-26197-1-git-send-email-sjenning@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374786680-26197-1-git-send-email-sjenning@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 04:11:20PM -0500, Seth Jennings wrote:
> +#define MEMFS_CLASS_NAME	"memoryfs"

One question, a "*fs" name in the kernel usually implies it is a
separate filesystem, which this isn't at all, it's just a "normal"
class/subsystem in the kernel.  So how about "memory" instead?

thanks,

greg k-h
