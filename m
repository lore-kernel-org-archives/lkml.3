Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbbAMS3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:29:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbbAMS3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:29:19 -0500
Message-ID: <1421173749.6540.1.camel@fourier>
Subject: Re: [PATCH][v3.13.y] e1000e: Fix no connectivity when driver loaded
 with cable out
From: Kamal Mostafa <kamal@canonical.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Kamal Mostafa <kamal.mostafa@canonical.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        davidx.m.ertman@intel.com, jeffrey.e.pieper@intel.com,
        jeffrey.t.kirsher@intel.com, LKML <linux-kernel@vger.kernel.org>,
        linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Tue, 13 Jan 2015 10:29:09 -0800
In-Reply-To: <5491B88E.3070906@canonical.com>
References: <5491B88E.3070906@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-17 at 12:08 -0500, Joseph Salisbury wrote:
> Hello,
> 
> Please consider including mainline commit b20a774 in the next v3.13.y
> stable release.  It was included in the mainline tree as of v3.15-rc1. 
> It has been tested and confirmed to resolve
> http://bugs.launchpad.net/bugs/1400365 .
> 
> commit b20a774495671f037e7160ea2ce8789af6b61533
> Author: David Ertman <davidx.m.ertman@intel.com>
> Date:   Tue Mar 25 04:27:55 2014 +0000
> 
>     e1000e: Fix no connectivity when driver loaded with cable out

Yes, I'll queue this up for the next 3.13-stable.  Thanks, Joseph!

 -Kamal

