Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966549Ab3DQPuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 11:50:11 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41089 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab3DQPuK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Wed, 17 Apr 2013 11:50:10 -0400
Message-Id: <516EE0FE02000078000CE422@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 17 Apr 2013 16:50:54 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "KY Srinivasan" <kys@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: "olaf@aepfle.de" <olaf@aepfle.de>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of
 Hyper-V
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417124852.GD6801@redhat.com>
 <3b76ebfdb240419aa601309465a4c154@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417132523.GB26157@redhat.com>
 <9ffd83acf6ac4a7bb5d51c95c96e6f50@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417134850.GB26335@redhat.com>
 <0cd5cde572734ea786664accc1a40bea@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <0cd5cde572734ea786664accc1a40bea@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.04.13 at 17:31, KY Srinivasan <kys@microsoft.com> wrote:
> If Xen were to change where it would not unconditionally emulate Hyper-V, I 
> would not be opposed to taking
> this check out.

But it doesn't do this unconditionally, only upon admin request.

Jan

