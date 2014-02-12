Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbaBLJce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:32:34 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:48412 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbaBLJcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:32:32 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstAo5SQMel8AXawDOUvwr8pxjMon91SD6m7JJcBA==
X-RZG-CLASS-ID: mo00
Date: Wed, 12 Feb 2014 10:32:26 +0100
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V5 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140212093226.GA19512@aepfle.de>
References: <1391922405-14105-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1391922405-14105-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, K. Y. Srinivasan wrote:

> +	fcopy_fd = open("/dev/vmbus/hv_fcopy", O_RDWR);
> +
> +	if (fcopy_fd < 0) {
> +		syslog(LOG_ERR, "open /dev/hv_fcopy failed; error: %d %s",

The error message mentions the old path.


Olaf
