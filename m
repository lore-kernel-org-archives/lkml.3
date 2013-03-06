Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3CFL60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:58:26 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:45389 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab3CFL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:58:23 -0500
Message-ID: <1362571097.7004.66.camel@par-r81vxc7.par.novell.com>
Subject: Re: [PATCH] efivarfs: fix abnormal GUID in variable name by using
 strcpy to replace null with dash
From: Frederic Crozat <fcrozat@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: joeyli <jlee@suse.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Schroeder <mls@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Wed, 06 Mar 2013 12:58:17 +0100
In-Reply-To: <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1362108018-13117-1-git-send-email-jlee@suse.com>
	 <1362151068.2842.440.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362155493.2842.446.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1362181299.23932.168.camel@linux-s257.site>
	 <1362555258.23932.573.camel@linux-s257.site>
	 <1362568750.15011.24.camel@mfleming-mobl1.ger.corp.intel.com>
Organization: SUSE
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 06 mars 2013 à 11:19 +0000, Matt Fleming a écrit :

> Also, which machine did you see this behaviour on?

HP z220 desktop, System BIOS K51 v 1.54

this issue is only the "Secure Boot" related variables, which make me
think HP incorrectly created them in their latest firmware (where they
added Windows 8 support).

-- 
Frederic Crozat <fcrozat@suse.com>
SUSE

