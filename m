Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbaE3Lwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:52:51 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53732 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933030AbaE3Lwt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:52:49 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range() instead of msleep()
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140530113418.GA9670@amd.pavel.ucw.cz>
Date: Fri, 30 May 2014 13:52:46 +0200
Cc: Miguel Oliveira <cmroliv@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        gulsah.1004@gmail.com,
        =?iso-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <7447FAB3-E22D-44C5-AD79-E366FEE57879@holtmann.org>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com> <20140530113418.GA9670@amd.pavel.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

>> Creating this patch for the Eudyptula Challenge.
>> Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
>> Also inserted a blank line after adeclaration.
> 
> So you are changing timings without testing. Plus, burning CPU power
> instead of sleeping.
> 
> Seems you'll need another patch for the challenge :-).

I actually wonder if anybody is seriously working on this driver. My concern with the staging drivers has always been that we are quick with merging them when the work on getting them into upstream shape is actually hard. However reality is once they are in staging nobody is doing the work to clean them up and fix the issues.

This one seems no exception. Merged in January and 5 month later none of the TODO items have been addressed. All the promises that we fix the issues in the staging tree went out the window.

Greg, instead of wasting our time with this, can we just remove this driver from staging.

Regards

Marcel

