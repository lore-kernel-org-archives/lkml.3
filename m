Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305Ab3BSIHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 03:07:15 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60199 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758350Ab3BSIHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 03:07:13 -0500
Message-ID: <1361261230.26423.9.camel@x61.thuisdomein>
Subject: Re: [PATCH] acer-wmi: do not use 'devices' uninitialized
From: Paul Bolle <pebolle@tiscali.nl>
To: joeyli <jlee@suse.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>
Date: Tue, 19 Feb 2013 09:07:10 +0100
In-Reply-To: <1361241494.6635.2.camel@linux-s257.site>
References: <1359033178.1325.15.camel@x61.thuisdomein>
	 <1361241494.6635.2.camel@linux-s257.site>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2013 08:07:11.0118 (UTC) FILETIME=[1E8462E0:01CE0E78]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joey.

On Tue, 2013-02-19 at 10:38 +0800, joeyli wrote:
> Zhang Rui sent similar patch for fix the warning:
> http://www.mail-archive.com/platform-driver-x86@vger.kernel.org/msg04016.html

I see. It didn't make it into the v3.8 release. Could someone please
send a note to the stable list once Zhang's patch hits mainline
(presumably in one of the v3.9 release candidates)?


Paul Bolle

