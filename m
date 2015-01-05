Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbbAEOY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:24:59 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:60443 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbbAEOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:24:58 -0500
Date: Mon, 5 Jan 2015 14:24:33 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Feng Tang <feng.tang@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>,
        Heesub Shin <heesub.shin@samsung.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: andriod: ion: Add ion_phys_get_by_id
 function
Message-ID: <20150105142433.1d892039@lxorguk.ukuu.org.uk>
In-Reply-To: <1420355512-31129-1-git-send-email-feng.tang@intel.com>
References: <1420355512-31129-1-git-send-email-feng.tang@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  4 Jan 2015 15:11:51 +0800
Feng Tang <feng.tang@intel.com> wrote:

> There is user case that user only knows the ion_handle idand
> needs to get the physical addr and len. So add this wrapper to
> meet this requirement.

What is the in-tree upstream user of this new function ? I don't see one
in your patches ?

Alan
