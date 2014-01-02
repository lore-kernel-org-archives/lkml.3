Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaABOzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 09:55:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaABOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 09:55:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131230152010.2d26d75b@nehalam.linuxnetplumber.net>
References: <20131230152010.2d26d75b@nehalam.linuxnetplumber.net>
To: Stephen Hemminger <shemming@brocade.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [PATCH] assoc_array: remove global variable
Date: Thu, 02 Jan 2014 14:55:00 +0000
Message-ID: <23507.1388674500@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemming@brocade.com> wrote:

> The associative array code creates unnecessary and potentially problematic
> global variable 'status'. Remove it since never used.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied.

David
