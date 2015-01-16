Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbbAPOVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:21:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbbAPOV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:21:27 -0500
Date: Fri, 16 Jan 2015 14:21:46 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        grant.likely@linaro.org, robh+dt@kernel.org,
        linux-acpi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH][v3.16.y-ckt] ACPICA: Add new GPE public interface -
 acpi_mark_gpe_for_wake.
Message-ID: <20150116142146.GD2438@charon>
References: <54B820E7.4080406@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B820E7.4080406@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 03:19:51PM -0500, Joseph Salisbury wrote:
> Hello,
> 
> Please consider including mainline commit c12f07d and bd9b2f9 in the
> next v3.16.y-ckt release.  They
> were included in the mainline tree as of v3.17-rc1.  A test kernel has
> been built and tested, which was confirmed to resolve:
> http://bugs.launchpad.net/bugs/1406767 .
> 
> commit c12f07d17c12193256a99e20c9a0f130fb8f7be8
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Wed Jul 23 13:12:16 2014 +0800
> 
>     ACPICA: Add new GPE public interface - acpi_mark_gpe_for_wake.
> 
> 
> Commit c12f07d does not cherry-pick cleanly in 3.16.y.  However, it will
> if commit bd9b2f9aff26c185c1f8e0cd08a850ee4ace391a is cherry picked first:
> 
> commit bd9b2f9aff26c185c1f8e0cd08a850ee4ace391a
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Mon Jul 14 22:41:41 2014 +0200
> 
>     ACPI / scan: No implicit wake notification for buttons
> 
>    
> 
>

Thanks, I'll queue both commits to the 3.16 kernel.

Cheers,
--
Luís


> Sincerely,
> Joseph Salisbury
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
