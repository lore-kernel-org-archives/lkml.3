Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966496Ab3DQOAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:00:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966321Ab3DQOAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:00:51 -0400
Date: Wed, 17 Apr 2013 16:01:02 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "bp@alien8.de" <bp@alien8.de>, "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Message-ID: <20130417130102.GE6801@redhat.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <516EC54A02000078000CE2AE@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516EC54A02000078000CE2AE@nat28.tlf.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 02:52:42PM +0100, Jan Beulich wrote:
> >>> On 17.04.13 at 15:20, KY Srinivasan <kys@microsoft.com> wrote:
> > If I recall correctly, the issue here was that Xen was enabling Hyper-V 
> > emulation un-conditionally even for Linux guests.
> 
> To make this a little more precise - Xen is doing so only when the
> guest config tells it to.
> 
> Jan

So it's something explicitly requested for this guest?  Then I don't
understand why does not make sense to override it in guest.
