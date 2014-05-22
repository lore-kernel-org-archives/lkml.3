Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaEVSPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:15:08 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:55735 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaEVSPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:15:06 -0400
MIME-Version: 1.0
In-Reply-To: <1400781753-2682-3-git-send-email-rui.zhang@intel.com>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <1400781753-2682-3-git-send-email-rui.zhang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 May 2014 12:14:44 -0600
Message-ID: <CAErSpo7PjPf8AK1ectzE1Ep-AQKSXHY8TfZatrOC8ZzbAcxjow@mail.gmail.com>
Subject: Re: [PATCH V7 02/11] PNPACPI: use whilte list for pnpacpi device enumeration
To: Zhang Rui <rui.zhang@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"white" is misspelled in the subject line.  I mentioned this before.

On Thu, May 22, 2014 at 12:02 PM, Zhang Rui <rui.zhang@intel.com> wrote:
> ACPI can be used to enumerate PNP devices, but the code does not
> handle this in a good manner.
> ...
