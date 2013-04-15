Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008Ab3DOGEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 02:04:46 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55557 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab3DOGEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 02:04:45 -0400
Message-ID: <516B9854.9080502@ti.com>
Date: Mon, 15 Apr 2013 11:34:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <thierry.reding@avionic-design.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <jacmet@sunsite.dk>
Subject: Re: [PATCH v5] ARM: davinci: da850: add EHRPWM & ECAP DT node
References: <1365595961-4060-1-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1365595961-4060-1-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2013 5:42 PM, Philip Avinash wrote:
> Add da850 EHRPWM & ECAP DT node along with pin-mux details.
> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> clock.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>

Looks good to me. Will try and see if this can make it to v3.10.

Thanks,
Sekhar
