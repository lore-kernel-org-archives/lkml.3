Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab3HZCao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:30:44 -0400
Received: from m12-11.163.com ([220.181.12.11]:55488 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab3HZCam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:30:42 -0400
Date: Mon, 26 Aug 2013 10:14:35 +0800
From: "=?utf-8?B?bGl1anVubGlhbmdfbGps?=" <liujunliang_ljl@163.com>
To: "=?utf-8?B?Sm9lIFBlcmNoZXM=?=" <joe@perches.com>
Cc: "=?utf-8?B?ZGF2ZW0=?=" <davem@davemloft.net>,
        "=?utf-8?B?aG9ybXM=?=" <horms@verge.net.au>,
        "=?utf-8?B?cm9taWV1?=" <romieu@fr.zoreil.com>,
        "=?utf-8?B?Z3JlZ2to?=" <gregkh@linuxfoundation.org>,
        "=?utf-8?B?bmV0ZGV2?=" <netdev@vger.kernel.org>,
        "=?utf-8?B?bGludXgtdXNi?=" <linux-usb@vger.kernel.org>,
        "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>,
        "=?utf-8?B?c3VuaGVjaGVuZw==?=" <sunhecheng@vip.126.com>
References: <1377343560-10524-1-git-send-email-liujunliang_ljl@163.com>,
 <1377368111.1757.2.camel@joe-AO722>
Subject: =?utf-8?B?UmU6IFJlOiBbUEFUQ0hdIFVTQjJORVQgOiBTUjk3MDAgOiBPbmUgY2hpcCBVU0IgMS4xIFVTQjJORVQgU1I5NzAwRGV2aWNlIERyaXZlciBTdXBwb3J0?=
Message-ID: <201308261014331251822@163.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
X-CM-TRANSID: C8CowED5D0sJuhpSuy+jAQ--.1577S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3tw15AryfGFW8Xry7tFyxXwb_yoWDXrykpF
	WUGa45JF4UXr1xXrZYyay8ua4Fvw1kJ3y7Cry3G34F9a43Ar1kXFy09342yryYk3yxCr4S
	kF4jk343Za15u3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j8EfrUUUUU=
X-CM-SenderInfo: xolxy3pqolt0hjboyzi6rwjhhfrp/1tbiRQKFX1EAGfMWyAAAs4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7Q2UpkG017575

Dear    Joe :
		
			I'm sorry to ask you that, do you need me to merge the patch and re-send it again.

		And which version of kernel will release this driver.
	
			Thanks a lot and apologizing for making you trouble.

			Thanks again.


2013-08-26 



liujunliang_ljl 



å‘ä»¶äººï¼š Joe Perches 
å‘é€æ—¶é—´ï¼š 2013-08-25  02:15:19 
æ”¶ä»¶äººï¼š liujunliang_ljl 
æŠ„é€ï¼š davem; horms; romieu; gregkh; netdev; linux-usb; linux-kernel; sunhecheng 
ä¸»é¢˜ï¼š Re: [PATCH] USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support 
 
Some whitespace and neatening fixups.
Some conversions from 4 indent tabs to normal tabs
Signed-off-by: Joe Perches <joe@perches.com>
---
Just doing this instead of commenting about spacing
again.
 drivers/net/usb/sr9700.c | 127 +++++++++++++++++++++++++----------------------
 1 file changed, 67 insertions(+), 60 deletions(-)
diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 27c86ec..4262b9d 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -29,7 +29,7 @@ static int sr_read(struct usbnet *dev, u8 reg, u16 length, void *data)
  int err;

  err = usbnet_read_cmd(dev, SR_RD_REGS, SR_REQ_RD_REG,
- 0, reg, data, length);
+       0, reg, data, length);
  if ((err != length) && (err >= 0))
  err = -EINVAL;
  return err;
@@ -40,7 +40,7 @@ static int sr_write(struct usbnet *dev, u8 reg, u16 length, void *data)
  int err;

  err = usbnet_write_cmd(dev, SR_WR_REGS, SR_REQ_WR_REG,
- 0, reg, data, length);
+        0, reg, data, length);
  if ((err >= 0) && (err < length))
  err = -EINVAL;
  return err;
@@ -54,19 +54,19 @@ static int sr_read_reg(struct usbnet *dev, u8 reg, u8 *value)
 static int sr_write_reg(struct usbnet *dev, u8 reg, u8 value)
 {
  return usbnet_write_cmd(dev, SR_WR_REGS, SR_REQ_WR_REG,
- value, reg, NULL, 0);
+ value, reg, NULL, 0);
 }

 static void sr_write_async(struct usbnet *dev, u8 reg, u16 length, void *data)
 {
  usbnet_write_cmd_async(dev, SR_WR_REGS, SR_REQ_WR_REG,
- 0, reg, data, length);
+        0, reg, data, length);
 }

 static void sr_write_reg_async(struct usbnet *dev, u8 reg, u8 value)
 {
  usbnet_write_cmd_async(dev, SR_WR_REGS, SR_REQ_WR_REG,
- value, reg, NULL, 0);
+        value, reg, NULL, 0);
 }

 static int wait_phy_eeprom_ready(struct usbnet *dev, int phy)
@@ -89,7 +89,7 @@ static int wait_phy_eeprom_ready(struct usbnet *dev, int phy)

  if (i >= SR_SHARE_TIMEOUT) {
  netdev_err(dev->net, "%s write timed out!\n",
- phy ? "phy" : "eeprom");
+    phy ? "phy" : "eeprom");
  ret = -EIO;
  goto out;
  }
@@ -98,7 +98,8 @@ out:
  return ret;
 }

-static int sr_share_read_word(struct usbnet *dev, int phy, u8 reg, __le16 *value)
+static int sr_share_read_word(struct usbnet *dev, int phy, u8 reg,
+       __le16 *value)
 {
  int ret;

@@ -115,14 +116,15 @@ static int sr_share_read_word(struct usbnet *dev, int phy, u8 reg, __le16 *value
  ret = sr_read(dev, EPDR, 2, value);

  netdev_dbg(dev->net, "read shared %d 0x%02x returned 0x%04x, %d\n",
- phy, reg, *value, ret);
+    phy, reg, *value, ret);

 out:
  mutex_unlock(&dev->phy_mutex);
  return ret;
 }

-static int sr_share_write_word(struct usbnet *dev, int phy, u8 reg, __le16 value)
+static int sr_share_write_word(struct usbnet *dev, int phy, u8 reg,
+        __le16 value)
 {
  int ret;

@@ -156,7 +158,8 @@ static int sr9700_get_eeprom_len(struct net_device *dev)
  return SR_EEPROM_LEN;
 }

-static int sr9700_get_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom, u8 *data)
+static int sr9700_get_eeprom(struct net_device *net,
+      struct ethtool_eeprom *eeprom, u8 *data)
 {
  struct usbnet *dev = netdev_priv(net);
  __le16 *ebuf = (__le16 *)data;
@@ -168,7 +171,8 @@ static int sr9700_get_eeprom(struct net_device *net, struct ethtool_eeprom *eepr
  return -EINVAL;

  for (i = 0; i < eeprom->len / 2; i++)
- ret = sr_read_eeprom_word(dev, eeprom->offset / 2 + i, &ebuf[i]);
+ ret = sr_read_eeprom_word(dev, eeprom->offset / 2 + i,
+   &ebuf[i]);

  return ret;
 }
@@ -199,12 +203,13 @@ static int sr_mdio_read(struct net_device *netdev, int phy_id, int loc)
  res = le16_to_cpu(res) & ~BMSR_LSTATUS;

  netdev_dbg(dev->net, "sr_mdio_read() phy_id=0x%02x, loc=0x%02x, returns=0x%04x\n",
- phy_id, loc, res);
+    phy_id, loc, res);

  return res;
 }

-static void sr_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
+static void sr_mdio_write(struct net_device *netdev, int phy_id, int loc,
+   int val)
 {
  struct usbnet *dev = netdev_priv(netdev);
  __le16 res = cpu_to_le16(val);
@@ -215,7 +220,7 @@ static void sr_mdio_write(struct net_device *netdev, int phy_id, int loc, int va
  }

  netdev_dbg(dev->net, "sr_mdio_write() phy_id=0x%02x, loc=0x%02x, val=0x%04x\n",
- phy_id, loc, val);
+    phy_id, loc, val);

  sr_share_write_word(dev, 1, loc, res);
 }
@@ -242,15 +247,15 @@ static int sr9700_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
 }

 static const struct ethtool_ops sr9700_ethtool_ops = {
- .get_drvinfo = usbnet_get_drvinfo,
- .get_link = sr9700_get_link,
- .get_msglevel = usbnet_get_msglevel,
- .set_msglevel = usbnet_set_msglevel,
- .get_eeprom_len = sr9700_get_eeprom_len,
- .get_eeprom = sr9700_get_eeprom,
- .get_settings = usbnet_get_settings,
- .set_settings = usbnet_set_settings,
- .nway_reset = usbnet_nway_reset,
+ .get_drvinfo = usbnet_get_drvinfo,
+ .get_link = sr9700_get_link,
+ .get_msglevel = usbnet_get_msglevel,
+ .set_msglevel = usbnet_set_msglevel,
+ .get_eeprom_len = sr9700_get_eeprom_len,
+ .get_eeprom = sr9700_get_eeprom,
+ .get_settings = usbnet_get_settings,
+ .set_settings = usbnet_set_settings,
+ .nway_reset = usbnet_nway_reset,
 };

 static void sr9700_set_multicast(struct net_device *net)
@@ -269,7 +274,7 @@ static void sr9700_set_multicast(struct net_device *net)
  if (net->flags & IFF_PROMISC) {
  rx_ctl |= RCR_PRMSC;
  } else if (net->flags & IFF_ALLMULTI ||
-   netdev_mc_count(net) > SR_MCAST_MAX) {
+    netdev_mc_count(net) > SR_MCAST_MAX) {
  rx_ctl |= RCR_RUNT;
  } else if (!netdev_mc_empty(net)) {
  struct netdev_hw_addr *ha;
@@ -290,7 +295,7 @@ static int sr9700_set_mac_address(struct net_device *net, void *p)

  if (!is_valid_ether_addr(addr->sa_data)) {
  netdev_err(net, "not setting invalid mac address %pM\n",
- addr->sa_data);
+    addr->sa_data);
  return -EINVAL;
  }

@@ -301,15 +306,15 @@ static int sr9700_set_mac_address(struct net_device *net, void *p)
 }

 static const struct net_device_ops sr9700_netdev_ops = {
- .ndo_open = usbnet_open,
- .ndo_stop = usbnet_stop,
- .ndo_start_xmit = usbnet_start_xmit,
- .ndo_tx_timeout = usbnet_tx_timeout,
- .ndo_change_mtu = usbnet_change_mtu,
- .ndo_validate_addr = eth_validate_addr,
- .ndo_do_ioctl = sr9700_ioctl,
- .ndo_set_rx_mode = sr9700_set_multicast,
- .ndo_set_mac_address = sr9700_set_mac_address,
+ .ndo_open = usbnet_open,
+ .ndo_stop = usbnet_stop,
+ .ndo_start_xmit = usbnet_start_xmit,
+ .ndo_tx_timeout = usbnet_tx_timeout,
+ .ndo_change_mtu = usbnet_change_mtu,
+ .ndo_validate_addr = eth_validate_addr,
+ .ndo_do_ioctl = sr9700_ioctl,
+ .ndo_set_rx_mode = sr9700_set_multicast,
+ .ndo_set_mac_address = sr9700_set_mac_address,
 };

 static int sr9700_bind(struct usbnet *dev, struct usb_interface *intf)
@@ -360,7 +365,8 @@ static int sr9700_bind(struct usbnet *dev, struct usb_interface *intf)

  sr_mdio_write(dev->net, dev->mii.phy_id, MII_BMCR, BMCR_RESET);
  sr_mdio_write(dev->net, dev->mii.phy_id,
- MII_ADVERTISE, ADVERTISE_ALL | ADVERTISE_CSMA | ADVERTISE_PAUSE_CAP);
+       (MII_ADVERTISE, ADVERTISE_ALL |
+        ADVERTISE_CSMA | ADVERTISE_PAUSE_CAP));
  mii_nway_restart(&dev->mii);

 out:
@@ -373,11 +379,11 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
  int len;

  /* skb content (packets) format :
-  * p0 p1 p2 ...... pm
-  *      /   \
-  * / \
-  * / \
-  *  / \
+  *                    p0            p1            p2    ......    pm
+  *                 /      \
+  *            /                \
+  *        /                            \
+  *  /                                        \
   * p0b0 p0b1 p0b2 p0b3 ...... p0b(n-4) p0b(n-3)...p0bn
   *
   * p0 : packet 0
@@ -431,7 +437,8 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
  return 0;
 }

-static struct sk_buff *sr9700_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
+static struct sk_buff *sr9700_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
+        gfp_t flags)
 {
  int len;

@@ -508,40 +515,40 @@ static int sr9700_link_reset(struct usbnet *dev)
  mii_ethtool_gset(&dev->mii, &ecmd);

  netdev_dbg(dev->net, "link_reset() speed: %d duplex: %d\n",
- ecmd.speed, ecmd.duplex);
+    ecmd.speed, ecmd.duplex);

  return 0;
 }

 static const struct driver_info sr9700_driver_info = {
- .description = "CoreChip SR9700 USB Ethernet",
- .flags = FLAG_ETHER,
- .bind = sr9700_bind,
- .rx_fixup = sr9700_rx_fixup,
- .tx_fixup = sr9700_tx_fixup,
- .status = sr9700_status,
- .link_reset = sr9700_link_reset,
- .reset = sr9700_link_reset,
+ .description = "CoreChip SR9700 USB Ethernet",
+ .flags = FLAG_ETHER,
+ .bind = sr9700_bind,
+ .rx_fixup = sr9700_rx_fixup,
+ .tx_fixup = sr9700_tx_fixup,
+ .status = sr9700_status,
+ .link_reset = sr9700_link_reset,
+ .reset = sr9700_link_reset,
 };

 static const struct usb_device_id products[] = {
  {
-  USB_DEVICE(0x0fe6, 0x9700), /* SR9700 device */
-  .driver_info = (unsigned long)&sr9700_driver_info,
-  },
+ USB_DEVICE(0x0fe6, 0x9700), /* SR9700 device */
+ .driver_info = (unsigned long)&sr9700_driver_info,
+ },
  {}, /* END */
 };

 MODULE_DEVICE_TABLE(usb, products);

 static struct usb_driver sr9700_usb_driver = {
- .name = "sr9700",
- .id_table = products,
- .probe = usbnet_probe,
- .disconnect = usbnet_disconnect,
- .suspend = usbnet_suspend,
- .resume = usbnet_resume,
- .disable_hub_initiated_lpm = 1,
+ .name = "sr9700",
+ .id_table = products,
+ .probe = usbnet_probe,
+ .disconnect = usbnet_disconnect,
+ .suspend = usbnet_suspend,
+ .resume = usbnet_resume,
+ .disable_hub_initiated_lpm = 1,
 };

 module_usb_driver(sr9700_usb_driver);
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
