Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAOQkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:40:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaAOQkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:40:22 -0500
Date: Wed, 15 Jan 2014 11:39:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, kosaki.motohiro@gmail.com,
        dyoung@redhat.com, linux-acpi@vger.kernel.org,
        kexec@lists.infradead.org
Subject: Re: [PATCH] acpi memory hotplug, add parameter to disable memory
 hotplug [v4]
Message-ID: <20140115163953.GB3180@redhat.com>
References: <alpine.DEB.2.02.1401141642020.3375@chino.kir.corp.google.com>
 <1389789284-10622-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389789284-10622-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 07:34:44AM -0500, Prarit Bhargava wrote:

[..]
> This patchset resolves the problem by adding a kernel parameter,
> acpi_no_memhotplug, to disable ACPI memory hotplug.
> 
> [v2]: changed acpi_no_memhotplug to bool
> [v3]: cleaned up Documentation/kernel-parameters.txt
> [v4]: add __initdata to acpi_no_memhotplug
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: kosaki.motohiro@gmail.com
> Cc: dyoung@redhat.com
> Cc: linux-acpi@vger.kernel.org
> Cc: kexec@lists.infradead.org

Hi Prarit,

Capture all the acks from V3 here so that people don't have to ack 
again. This is a minor change as compared to V3. 

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek
