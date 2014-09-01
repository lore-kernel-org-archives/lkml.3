Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbaIAMjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:39:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:48409 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbaIAMjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:39:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,442,1406617200"; 
   d="scan'208";a="566579876"
Message-ID: <1409575158.23772.47.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH] staging: goldfish_audio.c: sparse warning of incorrect
 type
From: Alan Cox <alan@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Sep 2014 13:39:18 +0100
In-Reply-To: <20140831200241.GA26833@kroah.com>
References: <1409501782-20775-1-git-send-email-sudipm.mukherjee@gmail.com>
	 <20140831200241.GA26833@kroah.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-31 at 13:02 -0700, Greg Kroah-Hartman wrote:
> Adding Alan Cox, as he pushed this driver upstream...

It's sort of a false positive. The existing code will work fine. 

Arguably all of this should be using the dma_ APIs.

Alan


