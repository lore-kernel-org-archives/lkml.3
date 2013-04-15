Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab3DOHUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:20:32 -0400
Received: from ozlabs.org ([203.10.76.45]:50814 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab3DOHUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:20:31 -0400
Date: Mon, 15 Apr 2013 17:20:27 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jkenisto@linux.vnet.ibm.com,
        mahesh@linux.vnet.ibm.com, anton@samba.org
Subject: Re: [PATCH 1/8] Remove syslog prefix in uncompressed oops text
Message-ID: <20130415072027.GA30156@concordia>
References: <20130410071835.20150.56489.stgit@aruna-ThinkPad-T420>
 <20130410072100.20150.74661.stgit@aruna-ThinkPad-T420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410072100.20150.74661.stgit@aruna-ThinkPad-T420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:51:00PM +0530, Aruna Balakrishnaiah wrote:
> Removal of syslog prefix in the uncompressed oops text will
> help in capturing more oops data.

Why does it help? Does this effect any existing tools?

cheers
