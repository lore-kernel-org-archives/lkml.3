Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaKDOIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:08:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:39133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKDOIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:08:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616832861"
Message-ID: <1415110071.26277.28.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH v2 0/3] Enable user helper interface for efi capsule
 update
From: Matt Fleming <matt.fleming@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Sam Protsenko" <semen.protsenko@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-efi@vger.kernel.org>, Ong Boon Leong <boon.leong.ong@intel.com>
Date: Tue, 4 Nov 2014 14:07:51 +0000
In-Reply-To: <20141104003849.GA15147@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
	 <5457D883.4050201@amacapital.net> <20141103212706.GE7379@kroah.com>
	 <CALCETrUNCuFvwkzbU4dWB0GH4mJKKV1e6jCNrSLVJe+n_et3kQ@mail.gmail.com>
	 <20141103230234.GA9427@kroah.com>
	 <CALCETrUtxqLaziC_f6iTEgKNhmTgJR6bOLJ=e=O22X_RsBc9sw@mail.gmail.com>
	 <20141104003849.GA15147@kroah.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 16:38 -0800, Greg Kroah-Hartman wrote:
> 
> Good point, I don't know.
> 
> Who ever wrote this code should know this, can someone please provide a
> use-case for how this is all supposed to work?

That would be Wilson. He's wanting to use this to send updates to the
firmware on the Intel Quark, I think.

