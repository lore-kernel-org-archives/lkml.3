Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3IWPwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:52:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44381 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3IWPwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:52:10 -0400
Message-ID: <5240632F.5070709@zytor.com>
Date: Mon, 23 Sep 2013 08:50:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>
CC: Gleb Natapov <gleb@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH V2 1/1] X86: Hyper-V: Get the local APIC timer frequency
 from the hypervisor
References: <1378233023-4512-1-git-send-email-kys@microsoft.com> <dd29077371564a14b2d317d2291db8a9@SN2PR03MB061.namprd03.prod.outlook.com> <52325C1E.90101@zytor.com> <50f92d9c16a54e5bb6fa14ef72e5fdfb@SN2PR03MB061.namprd03.prod.outlook.com> <20130913095526.GE18381@redhat.com> <7737cb643a664b6fb39021b4d364b5cf@SN2PR03MB061.namprd03.prod.outlook.com> <20130917135918.GY17294@redhat.com> <2b4a9a0cff5143c59a0802a2e425c4db@SN2PR03MB061.namprd03.prod.outlook.com> <20130918054335.GE5657@redhat.com> <2d39849c011b4cc794686a41e45db87a@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <2d39849c011b4cc794686a41e45db87a@SN2PR03MB061.namprd03.prod.outlook.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 06:02 AM, KY Srinivasan wrote:
> 
> Peter,
> Please let me know if there are other issues I need to address here. Now that Dmitry has queued up the
> Hyper-V keyboard driver, with this patch we can fully support Linux on our uefi firmware.
> 

I just got back from Plumber's -- this is on my short list of things to
look at.  If you haven't heard anything by Wednesday, ping me.

	-hpa


