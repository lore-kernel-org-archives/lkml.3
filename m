Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbaL3C0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 21:26:11 -0500
Received: from mail.lang.hm ([64.81.33.126]:34996 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaL3C0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 21:26:10 -0500
Date: Mon, 29 Dec 2014 18:25:55 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: Rob Landley <rob@landley.net>, Christophe Fillot <cf@utc.fr>,
        linux-ima-user@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-ima-user] Initramfs and IMA Appraisal
In-Reply-To: <1419889608.14143.40.camel@dhcp-9-2-203-236.watson.ibm.com>
Message-ID: <alpine.DEB.2.02.1412291824550.15184@nftneq.ynat.uz>
References: <5463ABC8.10308@utc.fr>  <1415827252.18773.33.camel@dhcp-9-2-203-236.watson.ibm.com>  <547617AF.6000604@utc.fr>  <1417039941.26016.46.camel@dhcp-9-2-203-236.watson.ibm.com>  <5476EBAC.8090103@utc.fr>  <1419860736.14143.13.camel@dhcp-9-2-203-236.watson.ibm.com>
  <54A1BAEE.6000101@landley.net> <1419889608.14143.40.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2014, Mimi Zohar wrote:

> Thanks Rob for the explanation.  The problem is that ramfs does not
> support extended attributes, while tmpfs does.  The boot loader could
> "measure" (trusted boot) the initramfs, but as the initramfs is
> generated on the target system, the initramfs is not signed, preventing
> it from being appraised (secure Boot). To close the initramfs integrity
> appraisal gap requires verifying the individual initramfs file
> signatures, which are stored as extended attributes.

what's the point of checking the files on the filesystem against signatures 
stored on the same filesystem? If someone could alter the file contents they can 
alter the signatures as well.

David Lang
