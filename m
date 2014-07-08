Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaGHSSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:18:33 -0400
Received: from smtp.citrix.com ([66.165.176.89]:19111 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166AbaGHSSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:18:32 -0400
X-IronPort-AV: E=Sophos;i="5.01,626,1400025600"; 
   d="scan'208";a="150681846"
Message-ID: <53BC35F5.1090206@citrix.com>
Date: Tue, 8 Jul 2014 19:18:29 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: <konrad@kernel.org>, <xen-devel@lists.xenproject.org>,
        <david.vrabel@citrix.com>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v3 1/7] xen-pciback: Document the various
 parameters and attributes in SysFS
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-2-git-send-email-konrad@kernel.org>
In-Reply-To: <1404845909-13563-2-git-send-email-konrad@kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.18]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 19:58, konrad@kernel.org wrote:
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>
> Which hadn't been done with the initial commit.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-pciback |   84 ++++++++++++++++++++++++
>  1 files changed, 84 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-driver-pciback
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentation/ABI/testing/sysfs-driver-pciback
> new file mode 100644
> index 0000000..4d2860c
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> @@ -0,0 +1,84 @@
> +What:           /sys//module/xen_pciback/parameters/verbose_request
>

s_//_/_ ?

~Andrew
