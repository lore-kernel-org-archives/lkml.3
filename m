Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422725AbaJ3XOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:14:09 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:49446 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161211AbaJ3XOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:14:07 -0400
Date: Thu, 30 Oct 2014 23:13:10 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Linux API <linux-api@vger.kernel.org>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
        Ryan Lortie <desrt@desrt.ca>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>, daniel@zonque.org,
        David Herrmann <dh.herrmann@gmail.com>, Paul Moore <pmoore@redhat.com>,
        "casey.schaufler@intel.com" <casey.schaufler@intel.com>,
        marcel@holtmann.org, tixxdz@opendz.org,
        javier.martinez@collabora.co.uk, alban.crequy@collabora.co.uk
Subject: Re: [PATCH 00/12] Add kdbus implementation
Message-ID: <20141030231310.0b65b762@alan.etchedpixels.co.uk>
In-Reply-To: <545297CC.6020306@samsung.com>
References: <54520A21.20404@samsung.com>
	<54521697.1030900@samsung.com>
	<20141030144709.GA19721@kroah.com>
	<545297CC.6020306@samsung.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The core calls are already mediated by LSM today, right?  We don't want
> > anyone to be parsing the data stream through an LSM, that idea got
> > rejected a long time ago as something that is really not a good idea.
> 
> Parsing data is out of question, of course, but this is not what we were
> proposing.

Why is it out of the question. If it's a socket you can just a BPF filter
on it, so why can't kdbus support similar basic functionality ?

Alan
