Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaCZNoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:44:14 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46140 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaCZNoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:44:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140325212417.GA6545@kroah.com>
References: <CA+5PVA6dz2ixLfHOHytkis6XmxdLKXZp9x8rEjB=pedrg7sXJQ@mail.gmail.com>
	<20140325212417.GA6545@kroah.com>
Date: Wed, 26 Mar 2014 09:44:11 -0400
X-Google-Sender-Auth: QAmbM2vWrcYOy-9jcHhjLlJqXfE
Message-ID: <CA+5PVA608SPM1r5tXwo_C+vaEff+XiLQ5AWwH7-i-MMGcXtuHw@mail.gmail.com>
Subject: Re: Feb. Fedora Kernel Patch Report
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Greg KH <greg@kroah.com>, mhocko@suse.cz
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 5:24 PM, Greg KH <greg@kroah.com> wrote:
> On Fri, Feb 28, 2014 at 10:13:29AM -0500, Josh Boyer wrote:
>> cgroup-fixes.patch (rhbz 1045755)
>> - Upstream commits 0ab02ca8f887908152d1a96db5130fc661d36a1e
>> - There was a 3.12 version of this patch sent to stable list from
>> Michal Hocko.  I don't remember why it wasn't applied, or why it
>> wasn't applied for 3.13.y...
>
> It didn't apply to 3.13, and I think I was waiting for a backported
> version, do you have one?

As far as I know we're using this version:

http://thread.gmane.org/gmane.linux.kernel.cgroups/10336/focus=1646465

The commentary on the thread seems to imply that Michal was going to
send it again for some reason.  Michal, did you send the 3.12/3.13
backport for this commit directly to stable?

josh
