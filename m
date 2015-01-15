Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbbAOMyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:54:51 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:61870 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbbAOMyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:54:49 -0500
MIME-Version: 1.0
In-Reply-To: <1421319786.27673.12.camel@linux-0dmf.site>
References: <1421293948-10901-1-git-send-email-chris@rorvick.com>
	<1421319786.27673.12.camel@linux-0dmf.site>
Date: Thu, 15 Jan 2015 06:54:49 -0600
X-Google-Sender-Auth: fL-kVDDWBixnEDxYnitauNkquJk
Message-ID: <CAEUsAPZime72Cu8prsVx8tabcj_KLoJG9V2j3S41S=z2w=acAQ@mail.gmail.com>
Subject: Re: [PATCH] usb: Fix typo in `struct usb_host_interface' comment
From: Chris Rorvick <chris@rorvick.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 5:03 AM, Oliver Neukum <oneukum@suse.de> wrote:
> On Wed, 2015-01-14 at 21:52 -0600, Chris Rorvick wrote:
>> The descriptor member `bNumEndpoints' is plural.
>
> I am afraid that is not a good idea. The name of a
> member of a structure mentioned in the specification should
> appear as it is used in the specification.

Where is it not plural in the specification?
