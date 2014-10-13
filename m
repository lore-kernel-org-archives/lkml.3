Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaJMTkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:40:24 -0400
Received: from forward1h.mail.yandex.net ([84.201.187.146]:33669 "EHLO
	forward1h.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaJMTkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:40:15 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2014 15:40:15 EDT
From: Erich Cordoba <erich.cordoba@yandex.com>
Envelope-From: erich-cordoba@yandex.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
In-Reply-To: <20141013032708.GB26646@kroah.com>
References: <1413167372-5568-1-git-send-email-erich.cordoba@yandex.com> <20141013032708.GB26646@kroah.com>
Subject: Re: [PATCH] staging: wlan-ng: Renamed prism2_fragmenthreshold in prism2mib.c
MIME-Version: 1.0
Message-Id: <527621413228747@web17h.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 13 Oct 2014 13:32:27 -0600
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea was to reduce the length of the line (to 80 characters) by renaming this function. 
But, now reviewing the result I can see that the name of the function has lost meaning. 
Please ignore this patch. 

-Erich

12.10.2014, 21:28, "Greg KH" <gregkh@linuxfoundation.org>:
> On Sun, Oct 12, 2014 at 09:29:32PM -0500, Erich Cordoba Malibran wrote:
>> šFrom: Erich Cordoba Malibran <erich.cordoba@yandex.com>
>>
>> šRenamed function to fix style issues.
>
> Why is changing a name, to a misspelled one, a "style issue fix"?
>> šSigned-off-by: Erich Cordoba Malibran <erich.cordoba@yandex.com>
>> š---
>> ššdrivers/staging/wlan-ng/prism2mib.c | 26 +++++++++++++-------------
>> šš1 file changed, 13 insertions(+), 13 deletions(-)
>>
>> šdiff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
>> šindex 0163e06..30d224f 100644
>> š--- a/drivers/staging/wlan-ng/prism2mib.c
>> š+++ b/drivers/staging/wlan-ng/prism2mib.c
>> š@@ -132,12 +132,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
>> ššššššššššššššššššššššššššššššššššššššššššstruct p80211msg_dot11req_mibset *msg,
>> ššššššššššššššššššššššššššššššššššššššššššvoid *data);
>>
>> š-static int prism2mib_fragmentationthreshold(struct mibrec *mib,
>> š- šššint isget,
>> š- šššwlandevice_t *wlandev,
>> š- šššhfa384x_t *hw,
>> š- šššstruct p80211msg_dot11req_mibset *msg,
>> š- šššvoid *data);
>> š+static int prism2mib_fragmenthreshold(struct mibrec *mib,
>> š+ šššššint isget,
>> š+ šššššwlandevice_t *wlandev,
>> š+ šššššhfa384x_t *hw,
>> š+ šššššstruct p80211msg_dot11req_mibset *msg,
>> š+ šššššvoid *data);
>>
>> ššstatic int prism2mib_priv(struct mibrec *mib,
>> ššššššššššššššššššššššššššššint isget,
>> š@@ -198,7 +198,7 @@ static struct mibrec mibtab[] = {
>> šššššššššš{DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
>> šššššššššššF_STA | F_READ | F_WRITE,
>> šššššššššššHFA384x_RID_FRAGTHRESH, 0, 0,
>> š- prism2mib_fragmentationthreshold},
>> š+ prism2mib_fragmenthreshold},
>> šššššššššš{DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
>> šššššššššššF_STA | F_READ,
>> šššššššššššHFA384x_RID_MAXTXLIFETIME, 0, 0,
>> š@@ -660,12 +660,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
>> šš*
>> šš----------------------------------------------------------------*/
>>
>> š-static int prism2mib_fragmentationthreshold(struct mibrec *mib,
>> š- šššint isget,
>> š- šššwlandevice_t *wlandev,
>> š- šššhfa384x_t *hw,
>> š- šššstruct p80211msg_dot11req_mibset *msg,
>> š- šššvoid *data)
>> š+static int prism2mib_fragmenthreshold(struct mibrec *mib,
>> š+ šššššint isget,
>> š+ šššššwlandevice_t *wlandev,
>> š+ šššššhfa384x_t *hw,
>> š+ šššššstruct p80211msg_dot11req_mibset *msg,
>> š+ šššššvoid *data)
>> šš{
>> ššššššššššint result;
>> ššššššššššu32 *uint32 = (u32 *) data;
>> š--
>> š2.1.2
>
> I don't understand the problem you are trying to solve here, what is it?
>
> confused,
>
> greg k-h
