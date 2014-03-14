Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbaCNV3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:29:44 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:48260 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbaCNV3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:29:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140314211456.GA23213@amd.pavel.ucw.cz>
References: <20140314211456.GA23213@amd.pavel.ucw.cz>
Date: Fri, 14 Mar 2014 17:29:41 -0400
X-Google-Sender-Auth: 6aHJllx4HVPcryzAmUW1UdtorU0
Message-ID: <CAKb7Uvi-GfOu3_3BMU_Cu4qYS8PQRWzxVm1XETY7y_TJjGPs_A@mail.gmail.com>
Subject: Re: 3.14-rc: /proc/acpi/battery gone?
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 5:14 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> It seems /proc/acpi/battery interface is gone, and I don't see any
> option to reintroduce it... what is going on?

The interface went away in a semi-recent kernel release (3.13 or
3.12), breaking pretty much every battery app. (Admittedly the
interface was marked as deprecated for quite some time, but that
didn't stop everyone from using it and not caring about the new
thing.) I've yet to find a windowmaker dock app that works with the
current sysfs API :(

  -ilia
