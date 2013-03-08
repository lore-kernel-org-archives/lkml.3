Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3CHGiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:38:50 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:46189 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3CHGit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:38:49 -0500
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Schroeder <mls@suse.com>, Josh Boyer <jwboyer@redhat.com>,
        Peter Jones <pjones@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Frederic Crozat <fcrozat@suse.com>
In-Reply-To: <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362652440.28562.26.camel@linux-s257.site>
	 <1362656348.15011.166.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Mar 2013 14:37:12 +0800
Message-ID: <1362724632.28562.368.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-03-07 於 11:39 +0000，Matt Fleming 提到：
> > This patch works on a normal UEFI machine, we will test it on HP
> z220. I
> > will send out it formally after test success.
> 
> Has anyone tried contacting HP to tell them their firmware is doing
> bizarre things?

We will try to contact with HP workstation department.
Another good chance is in UEFI Plugfest Taipei at next next week, I will
discuss with HP engineer for this issue.


Thanks a lot!
Joey Lee



