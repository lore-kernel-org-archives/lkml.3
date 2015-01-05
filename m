Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbbAEWSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:18:53 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:55847 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbbAEWSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:18:52 -0500
Message-ID: <1420496330.14308.37.camel@x220>
Subject: Re: [PATCH 0/5] *** SUBJECT HERE ***
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Zapalowicz <bergo.torino@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        pankaj.saraf@nektech.in, linux-kernel@vger.kernel.org,
        abbotti@mev.co.uk, jitendra kumar khasdev <jkhasdev@gmail.com>
Date: Mon, 05 Jan 2015 23:18:50 +0100
In-Reply-To: <20150104014119.GE25819@t400>
References: <1420274187-6779-1-git-send-email-jkhasdev@gmail.com>
	 <20150103164516.GB30268@kroah.com> <1420325674.9624.65.camel@x220>
	 <20150104014119.GE25819@t400>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jan 2015 22:18:50.0828 (UTC) FILETIME=[954818C0:01D02935]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-04 at 02:41 +0100, Konrad Zapalowicz wrote:
> git send-email does one thing and one thing only - sends stuff via
> email. I do not see why it should parse the emails and decide whether to
> complete the operation or break based on what is in the emails.

It already has to parse the file(s) it's provided with. Perhaps it
already has checks to validate Subject: lines. Would an extra test be a
burden?

> It could
> warn though however since the cover letter is a product of different
> command introducing this logic would tightly couple those which is not
> good.

A warning would be too late: the message with the silly subject would be
already sent out.

> I guess that it is better that people who send stuff acctually care what
> they are sending. I mean that pretty quickly you learn to send the
> series of patches first to yourself and review before it goes out to the
> public.

It's good if people are careful. It's also good if programs help to
avoid silly mistakes.


Paul Bolle

