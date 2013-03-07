Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab3CGPCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 10:02:45 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63326 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759214Ab3CGPCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 10:02:42 -0500
Message-ID: <1362668558.15011.203.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: Problem mounting efivarfs in 3.9
From: Matt Fleming <matt.fleming@intel.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        stable@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 07 Mar 2013 15:02:38 +0000
In-Reply-To: <20130307145601.GA24233@thinkpad-t410>
References: <20130307145601.GA24233@thinkpad-t410>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-07 at 08:56 -0600, Seth Forshee wrote:
> Hi Matt,
> 
> I found myself unable to mount efivarfs on one of my machines in 3.9.
> This is due to your patch to be more aggressive about validating
> filenames. This machine had some crash dumps from pstore, which start
> with "dump-type". However now efivars expects the guid to follow the
> first '-' character, despite the fact that the efivars pstore code is
> creating the file names starting with dump-type. Since these names fail
> the validation the mount fails.

A patch to allow pstore names is in the pull request I sent to Peter and
Ingo yesterday,

	http://marc.info/?l=linux-kernel&m=136258373231608&w=2


